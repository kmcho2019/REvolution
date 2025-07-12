module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Lower 8 bits use traditional counting
wire [7:0] lower_next = up_down ? count[7:0] + 1'b1 : count[7:0] - 1'b1;

// Upper 8 bits use optimized pattern transitions
wire lower_wrap = up_down ? (count[7:0] == 8'hFF) : (count[7:0] == 8'h00);
wire [7:0] upper_next;

// Pattern-based transition for upper bits
always @(*) begin
    if (lower_wrap) begin
        if (up_down) begin
            // Optimized increment pattern for upper bits
            upper_next[0] = ~count[8];
            upper_next[1] = count[9] ^ (count[8] & ~count[10]);
            upper_next[2] = count[10] ^ (count[8] & count[9]);
            upper_next[3] = count[11] ^ (count[8] & count[10]);
            upper_next[4] = count[12] ^ (count[9] & count[10]);
            upper_next[5] = count[13] ^ (count[8] & count[11]);
            upper_next[6] = count[14] ^ (count[9] & count[11]);
            upper_next[7] = count[15] ^ (count[10] & count[11]);
        end else begin
            // Optimized decrement pattern for upper bits
            upper_next[0] = ~count[8];
            upper_next[1] = count[9] ^ (count[8] | count[10]);
            upper_next[2] = count[10] ^ (count[8] | count[9]);
            upper_next[3] = count[11] ^ (count[8] | count[10]);
            upper_next[4] = count[12] ^ (count[9] | count[10]);
            upper_next[5] = count[13] ^ (count[8] | count[11]);
            upper_next[6] = count[14] ^ (count[9] | count[11]);
            upper_next[7] = count[15] ^ (count[10] | count[11]);
        end
    end else begin
        upper_next = count[15:8];
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {upper_next, lower_next};
    end
end

// Verification logic (can be removed in synthesis)
wire [15:0] expected_next = up_down ? count + 1'b1 : count - 1'b1;
always @(posedge clk) begin
    if (!reset && {upper_next, lower_next} != expected_next) begin
        $display("Error: Mismatch at time %t", $time);
    end
end

endmodule