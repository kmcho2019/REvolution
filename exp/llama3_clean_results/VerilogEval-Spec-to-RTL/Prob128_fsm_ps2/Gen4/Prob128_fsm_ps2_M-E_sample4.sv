module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define the pipeline stages
logic [7:0] byte1, byte2, byte3;
logic [2:0] valid;  // Valid bits for each stage

always_ff @(posedge clk) begin
    if(reset) begin
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
        valid <= 3'b000;
    end
    else begin
        // Shift pipeline stages
        byte3 <= byte2;
        byte2 <= byte1;
        byte1 <= in;

        // Update valid bits
        if(in[3] == 1'b1) begin
            valid <= 3'b100;  // New message starts
        end
        else if(valid[0] == 1'b1) begin
            valid <= {valid[1:0], 1'b1};  // Shift valid bits
        end
        else if(valid == 3'b000) begin
            valid <= 3'b000;  // Reset valid bits
        end
    end
end

assign done = valid[2];  // Assert done when all three bytes are valid

endmodule