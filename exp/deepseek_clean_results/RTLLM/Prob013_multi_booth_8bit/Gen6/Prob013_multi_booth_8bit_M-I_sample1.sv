module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // States for the multiplier
    typedef enum {RESET, CALC, DONE} state_t;
    reg [1:0] state;

    // Internal registers
    reg [15:0] A_reg;    // Multiplicand (sign extended)
    reg [8:0] Q_reg;      // Multiplier with extra bit
    reg [1:0] count;      // Iteration counter (0-3)
    reg q_1;              // Previous LSB for Booth encoding

    // State definitions
    localparam RESET  = 2'b00;
    localparam CALC   = 2'b01;
    localparam DONE   = 2'b10;

    always @(posedge clk) begin
        case (state)
            RESET: begin
                // Initialize registers with sign extension
                A_reg <= {{8{a[7]}}, a};
                Q_reg <= {b, 1'b0};  // Multiplier with extra bit
                p <= 16'b0;
                count <= 2'b0;
                q_1 <= 1'b0;
                rdy <= 1'b0;
                
                if (!reset) state <= CALC;
            end

            CALC: begin
                if (count < 4) begin
                    // Booth encoding and operation
                    case (Q_reg[1:0], q_1)
                        3'b000, 3'b111: ; // No operation
                        3'b001, 3'b010: p <= p + A_reg;
                        3'b101, 3'b110: p <= p - A_reg;
                        3'b011: p <= p + (A_reg << 1);
                        3'b100: p <= p - (A_reg << 1);
                    endcase

                    // Arithmetic right shift (preserve sign)
                    {A_reg, Q_reg, q_1} <= {A_reg[15], A_reg, Q_reg[8:1]};
                    count <= count + 1;
                end
                else begin
                    state <= DONE;
                    rdy <= 1'b1;
                end
            end

            DONE: begin
                // Maintain output until next reset
                if (reset) state <= RESET;
            end
        endcase
    end

    // Handle asynchronous reset
    always @(posedge reset) begin
        if (reset) begin
            state <= RESET;
            p <= 16'b0;
            rdy <= 1'b0;
        end
    end

endmodule