module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;
reg [2:0] state; // States: 0 - Idle, 1 - Multiply, 2 - Done

localparam IDLE = 3'b001;
localparam MULTIPLY = 3'b010;
localparam DONE = 3'b100;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= MULTIPLY;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    i <= 5'd1;
                end
            end
            MULTIPLY: begin
                if (i < 5'd17) begin
                    if (areg[i-1] == 1'b1) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1'b1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                done_r <= 1'b1;
                if (!start) begin
                    state <= IDLE;
                    done_r <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign yout = yout_r;
assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule