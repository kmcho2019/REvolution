module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [31:0] yout_r;
reg [4:0] i;
reg [15:0] areg;
reg [15:0] breg;
reg [2:0] state; // States: 0 - Idle, 1 - Multiply, 2 - Done

localparam IDLE = 3'b001;
localparam MULTIPLY = 3'b010;
localparam DONE = 3'b100;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        i <= 0;
        yout_r <= 0;
        areg <= 0;
        breg <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= MULTIPLY;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 0;
                    i <= 1;
                end
            end
            MULTIPLY: begin
                if (i < 17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                end
                if (i == 16) begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1;
                if (!start) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign yout = yout_r;

endmodule