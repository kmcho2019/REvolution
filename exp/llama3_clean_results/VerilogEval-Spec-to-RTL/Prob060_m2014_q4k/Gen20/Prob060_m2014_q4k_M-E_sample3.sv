// Ring Counter Module with Active-Low Synchronous Reset
module RingCounter(
    input clk,
    input resetn,
    output reg [1:0] count
);

always @(posedge clk) begin
    if (!resetn) begin
        count <= 2'b00;
    end else begin
        if (count == 2'b11) begin
            count <= 2'b00;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule

// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Ring Counter Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [1:0] count;
reg [3:0] q;

// Instantiate the ring counter module
RingCounter ring_counter(clk, resetn, count);

// Instantiate four D flip-flop modules
DFF dff0(clk, resetn, (count == 2'b00) ? in : q[1], q[0]);
DFF dff1(clk, resetn, (count == 2'b01) ? q[0] : q[2], q[1]);
DFF dff2(clk, resetn, (count == 2'b10) ? q[1] : q[3], q[2]);
DFF dff3(clk, resetn, (count == 2'b11) ? q[2] : 1'b0, q[3]);

// Assign output directly from the last D flip-flop
assign out = q[3];

endmodule