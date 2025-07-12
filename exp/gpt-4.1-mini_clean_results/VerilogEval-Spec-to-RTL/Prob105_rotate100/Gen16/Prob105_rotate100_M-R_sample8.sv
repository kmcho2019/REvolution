module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Function to calculate next state of the rotator
    function [99:0] rotate_next;
        input [99:0] curr;
        input [1:0] ena_in;
        input load_in;
        input [99:0] data_in;
        begin
            if (load_in) begin
                rotate_next = data_in;
            end else if (ena_in == 2'b10) begin
                // Rotate left by 1
                rotate_next = {curr[98:0], curr[99]};
            end else if (ena_in == 2'b01) begin
                // Rotate right by 1
                rotate_next = {curr[0], curr[99:1]};
            end else begin
                // Hold current state
                rotate_next = curr;
            end
        end
    endfunction

    wire [99:0] next_q = rotate_next(q, ena, load, data);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule