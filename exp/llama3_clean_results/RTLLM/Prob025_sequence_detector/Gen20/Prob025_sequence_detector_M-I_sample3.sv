module sequence_detector(
    input clk,
    input rst_n, 
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg; 

// Clock gating
reg clock_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock_gated <= 1'b0;
    end else if (data_in == 1'b1) begin
        clock_gated <= 1'b1;
    end else begin
        clock_gated <= 1'b0;
    end
end

// Shift register logic with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0000;
    end else if (clock_gated) begin
        shift_reg <= {data_in, shift_reg[3:1]};
    end
end

// Comparator logic
assign sequence_detected = (shift_reg == 4'b1001);

endmodule