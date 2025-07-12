module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam LOAD = 3'b010;
    localparam CALC = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [30:0] shifted_bin; // Max shift is 15 (16+15=31 bits needed)
    wire acc_enable = (state == CALC) && areg[count];

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

    // Shifted bin computation (only in CALC state)
    always @(*) begin
        if (state == CALC) begin
            shifted_bin = bin << count;
        end else begin
            shifted_bin = 31'b0;
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                LOAD: begin
                    areg <= ain;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    if (acc_enable) begin
                        acc <= acc + {1'b0, shifted_bin};
                    end
                    count <= count + 1;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == CALC) && (count == 15);

endmodule