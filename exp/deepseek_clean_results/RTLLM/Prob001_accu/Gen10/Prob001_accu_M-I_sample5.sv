module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [2:0] count;          // 3-bit counter for better encoding
    reg [9:0] stage1_acc;     // First stage accumulator (inputs 0-1)
    reg [9:0] stage2_acc;     // Second stage accumulator (inputs 2-3)
    reg gated_clk;            // Gated clock signal
    
    // Clock gating logic
    always @(*) begin
        gated_clk = clk & (valid_in | (count != 0));
    end

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'b000;
            stage1_acc <= 10'b0;
            stage2_acc <= 10'b0;
        end
        else if (valid_in) begin
            case (count[1:0])
                2'b00: begin
                    stage1_acc <= data_in;
                    count <= count + 1;
                end
                2'b01: begin
                    stage1_acc <= stage1_acc + data_in;
                    count <= count + 1;
                end
                2'b10: begin
                    stage2_acc <= stage1_acc + data_in;
                    count <= count + 1;
                end
                2'b11: begin
                    // Final accumulation happens here
                    stage2_acc <= 10'b0;
                    stage1_acc <= 10'b0;
                    count <= 3'b000;
                end
            endcase
        end
    end

    // Output logic (non-gated clock domain)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            if (valid_in && count == 3'b011) begin
                data_out <= stage2_acc + data_in;
                valid_out <= 1'b1;
            end
        end
    end

endmodule