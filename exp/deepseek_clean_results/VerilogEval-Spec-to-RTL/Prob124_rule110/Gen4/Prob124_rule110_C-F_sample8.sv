module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    reg [513:0] temp_q;  // Extended register for uniform processing

    always @(*) begin
        if (load) begin
            next_q = q;  // No computation needed when loading
        end else begin
            // Create extended register with boundary zeros
            temp_q = {1'b0, q, 1'b0};
            
            // Process all bits uniformly
            for (int i = 0; i < 512; i = i + 1) begin
                case (temp_q[i+2:i])
                    3'b111: next_q[i] = 1'b0;
                    3'b110: next_q[i] = 1'b1;
                    3'b101: next_q[i] = 1'b1;
                    3'b100: next_q[i] = 1'b0;
                    3'b011: next_q[i] = 1'b1;
                    3'b010: next_q[i] = 1'b1;
                    3'b001: next_q[i] = 1'b1;
                    3'b000: next_q[i] = 1'b0;
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule