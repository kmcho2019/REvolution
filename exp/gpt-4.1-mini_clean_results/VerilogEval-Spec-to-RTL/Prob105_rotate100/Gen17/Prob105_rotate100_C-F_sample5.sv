module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to select next state based on load and rotation enable
    always @* begin
        if (load) begin
            next_q = data;               // synchronous load
        end else if (ena == 2'b10) begin
            next_q = {q[98:0], q[99]};  // rotate left by 1
        end else if (ena == 2'b01) begin
            next_q = {q[0], q[99:1]};   // rotate right by 1
        end else begin
            next_q = q;                 // hold current value
        end
    end

    // Sequential update on clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule