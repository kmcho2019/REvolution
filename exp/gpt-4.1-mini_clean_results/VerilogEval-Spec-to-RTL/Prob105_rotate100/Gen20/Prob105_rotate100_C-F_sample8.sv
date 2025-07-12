module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    // Precompute rotated versions of q for use in the next state function
    wire [99:0] rotated_left  = {q[98:0], q[99]};
    wire [99:0] rotated_right = {q[0], q[99:1]};

    // Function to determine the next state of the rotator
    function [99:0] compute_next;
        input [99:0] curr;
        input [1:0] ena_in;
        input load_in;
        input [99:0] data_in;
        input [99:0] rot_left;
        input [99:0] rot_right;
        begin
            if (load_in) begin
                compute_next = data_in;
            end else if (ena_in == 2'b10) begin
                compute_next = rot_left;
            end else if (ena_in == 2'b01) begin
                compute_next = rot_right;
            end else begin
                compute_next = curr;
            end
        end
    endfunction

    wire [99:0] next_q = compute_next(q, ena, load, data, rotated_left, rotated_right);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule