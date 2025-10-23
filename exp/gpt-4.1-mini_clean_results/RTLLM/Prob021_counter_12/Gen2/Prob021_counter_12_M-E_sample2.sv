module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    reg clear;  // synchronous clear signal

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end else if (clear) begin
            out <= 4'b0000;
        end else if (valid_count) begin
            out <= out + 1;
        end
        // else hold value when valid_count=0
    end

    // Synchronous clear is asserted when out reaches 11
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clear <= 1'b0;
        end else begin
            // Clear on next clock when count hits 11
            clear <= (valid_count && (out == 4'd11));
        end
    end

endmodule