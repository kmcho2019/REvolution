module TopModule (
    input               clk,
    input               load,
    input      [511:0]  data,
    output reg [511:0]  q
);

    localparam WIDTH = 512;

    // Function to compute next state bit by bit with boundary zero conditions
    function automatic logic next_bit;
        input integer idx;
        input [WIDTH-1:0] current_state;
        begin
            // Left neighbor (0 if idx == 0)
            logic left = (idx == 0) ? 1'b0 : current_state[idx-1];
            // Right neighbor (0 if idx == WIDTH-1)
            logic right = (idx == WIDTH-1) ? 1'b0 : current_state[idx+1];
            next_bit = left ^ right;
        end
    endfunction

    wire [WIDTH-1:0] next_state;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_next_state
            assign next_state[i] = next_bit(i, q);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule