module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Start bit detection module
reg start_detected;
always @(posedge clk) begin
    if (reset) begin
        start_detected <= 1'b0;
    end else if (~in) begin
        start_detected <= 1'b1;
    end else if (start_detected) begin
        start_detected <= 1'b0;
    end
end

// Data reception module
reg [7:0] data;
reg [2:0] bit_count;
always @(posedge clk) begin
    if (reset) begin
        data <= 8'b0;
        bit_count <= 3'b0;
    end else if (start_detected) begin
        if (bit_count == 3'b0) begin
            data <= {7'b0, in};
            bit_count <= bit_count + 1;
        end else if (bit_count < 3'b111) begin
            data <= {data[6:0], in};
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end
end

// Stop bit verification module
reg stop_bit_correct;
always @(posedge clk) begin
    if (reset) begin
        stop_bit_correct <= 1'b0;
    end else if (bit_count == 3'b111) begin
        if (in) begin
            stop_bit_correct <= 1'b1;
        end else begin
            stop_bit_correct <= 1'b0;
        end
    end
end

// Main logic
always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (start_detected && bit_count == 3'b111 && stop_bit_correct) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule