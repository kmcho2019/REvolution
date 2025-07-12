module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] bit_cnt;
    reg [15:0] areg, breg;
    reg [31:0] acc;
    wire [31:0] shifted_b [0:15];

    // Pre-calculate all possible shifted versions of B
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = {16'b0, breg} << i;
        end
    endgenerate

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'b0;
                        bit_cnt <= 4'b0;
                    end
                end
                
                CALC: begin
                    if (areg[bit_cnt]) begin
                        acc <= acc + shifted_b[bit_cnt];
                    end
                    bit_cnt <= bit_cnt + 1;
                end
                
                DONE: begin
                    yout <= acc;
                    bit_cnt <= 4'b0;
                end
            endcase
            
            // Registered done signal
            done <= (state == DONE);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (bit_cnt == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule