module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i; // shift count register
reg [15:0] areg; // multiplicand register
reg [15:0] breg; // multiplier register
reg [31:0] yout_r; // product register
reg done_r; // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        i <= 5'd0;
        done_r <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i < 5'd16) begin
            i <= i + 1'b1;
            if (i == 5'd1) begin // load inputs to registers
                areg <= ain;
                breg <= bin;
            end
            if (i > 5'd1 && areg[15 - (i - 1)]) begin // shift and accumulate
                yout_r <= yout_r + ({16'd0, breg} << (i - 1));
            end
            if (i == 5'd16) begin // completion flag
                done_r <= 1'b1;
            end
        end
    end else begin
        i <= 5'd0;
    end
end

assign yout = yout_r;
assign done = (i == 5'd16) ? 1'b1 : (done_r && (i == 5'd17)) ? 1'b0 : done_r;

endmodule