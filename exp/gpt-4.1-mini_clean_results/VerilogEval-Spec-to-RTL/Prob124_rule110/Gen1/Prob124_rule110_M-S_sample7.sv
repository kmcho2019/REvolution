module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [513:0] ext_q;  // extended q with zeros at both ends: bits [513] down to [0]
    reg [511:0] next_state;
    integer i;

    always @* begin
        // Extend q with zero padding at boundaries for simpler neighbor indexing
        ext_q = {1'b0, q, 1'b0};

        for (i = 0; i < 512; i = i + 1) begin
            // left = ext_q[i+2], center = ext_q[i+1], right = ext_q[i]
            // Implement rule110 directly as per truth table:
            // next = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right)
            next_state[i] = 
                  (ext_q[i+2] &  ext_q[i+1] & ~ext_q[i]) 
                | (ext_q[i+2] & ~ext_q[i+1] &  ext_q[i]) 
                | (~ext_q[i+2] &  ext_q[i+1] &  ext_q[i]) 
                | (~ext_q[i+2] &  ext_q[i+1] & ~ext_q[i]) 
                | (~ext_q[i+2] & ~ext_q[i+1] &  ext_q[i]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule