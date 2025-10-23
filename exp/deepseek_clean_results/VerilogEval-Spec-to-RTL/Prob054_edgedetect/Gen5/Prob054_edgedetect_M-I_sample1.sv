module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev;
    reg prev_change;

    always @(posedge clk) begin
        // Only update registers if input changed
        if (prev_change || (in != prev)) begin
            pedge <= in & ~prev;
            prev <= in;
            prev_change <= 1'b0;
        end else begin
            prev_change <= (in != prev);
            pedge <= 8'b0;
        end
    end

endmodule