module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Message start flag
logic message_start;

// Byte counter
logic [1:0] byte_count;

// Done signal generation
logic done_next;

// Register logic
always_ff @(posedge clk) begin
    if (reset) begin
        message_start <= 0;
        byte_count <= 0;
        done <= 0;
    end else begin
        message_start <= (in[3]) ? 1 : (byte_count != 0) ? 1 : 0;
        byte_count <= (message_start) ? byte_count + 1 : 0;
        done <= done_next;
    end
end

// Done signal generation logic
always_comb begin
    done_next = (byte_count == 3) ? 1 : 0;
end

endmodule