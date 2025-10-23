module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    reg [8:0] update_idx; // 9 bits for [0..511]
    
    wire left_bit, right_bit;
    wire next_bit;

    // Handle boundaries with zero neighbors
    assign left_bit  = (update_idx == 0)   ? 1'b0 : q[update_idx - 1];
    assign right_bit = (update_idx == 511) ? 1'b0 : q[update_idx + 1];
    assign next_bit = left_bit ^ right_bit;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            update_idx <= 0;
        end else begin
            // Update the cell at update_idx with next_bit
            q[update_idx] <= next_bit;
            // Increment the update index modulo 512
            if (update_idx == 511)
                update_idx <= 0;
            else
                update_idx <= update_idx + 1;
        end
    end

endmodule