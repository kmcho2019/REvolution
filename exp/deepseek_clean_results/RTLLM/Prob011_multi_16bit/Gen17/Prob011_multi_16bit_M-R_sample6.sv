module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    // Control signals
    reg [1:0] state, next_state;
    reg [3:0] bit_cnt;
    reg [15:0] areg;
    reg [15:0] breg;
    wire [31:0] shifted_b = {16'b0, breg} << bit_cnt;

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
            CALC: next_state = (bit_cnt == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_cnt <= 4'b0;
                    yout <= 32'b0;
                    done <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                end
                CALC: begin
                    if (areg[bit_cnt]) begin
                        yout <= yout + shifted_b;
                    end
                    bit_cnt <= bit_cnt + 1;
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule