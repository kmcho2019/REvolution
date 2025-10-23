module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Function to compute index with wrap-around (mod 100)
    function integer rot_idx;
        input integer base;
        input integer offset;
        begin
            rot_idx = (base + offset + 100) % 100;
        end
    endfunction

    integer i;
    reg [99:0] q_next;

    always @* begin
        if (load) begin
            q_next = data;
        end else if (ena == 2'b10) begin  // rotate left by 1
            for (i = 0; i < 100; i = i + 1) begin
                q_next[i] = q[rot_idx(i,1)];
            end
        end else if (ena == 2'b01) begin  // rotate right by 1
            for (i = 0; i < 100; i = i + 1) begin
                q_next[i] = q[rot_idx(i,-1)];
            end
        end else begin
            q_next = q;
        end
    end

    always @(posedge clk) begin
        q <= q_next;
    end

endmodule