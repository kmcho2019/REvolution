module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [7:0] segment [7:0];
wire [7:0] next_segment [7:0];
reg [2:0] shift_amount;

always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 8; i++) begin
            segment[i] <= data[(i*8)+:8];
        end
    end else if (ena) begin
        case (amount)
            2'b00: begin
                for (int i = 0; i < 7; i++) begin
                    segment[i] <= {segment[i][6:0], 1'b0};
                end
                segment[7] <= {segment[7][6:0], 1'b0};
            end
            2'b01: begin
                for (int i = 0; i < 7; i++) begin
                    segment[i] <= {8'd0, segment[i][7:1]};
                end
                segment[7] <= {8'd0, segment[7][7:1]};
            end
            2'b10: begin
                for (int i = 1; i < 8; i++) begin
                    segment[i] <= {segment[i-1][7], segment[i][7:1]};
                end
                segment[0] <= {segment[0][7], segment[0][6:0]};
            end
            2'b11: begin
                for (int i = 1; i < 8; i++) begin
                    segment[i] <= {{8{segment[i-1][7]}}, segment[i-1][7:1]};
                end
                segment[0] <= {{8{segment[0][7]}}, segment[0][7:1]};
            end
        endcase
    end
end

assign q = {segment[7], segment[6], segment[5], segment[4], segment[3], segment[2], segment[1], segment[0]};

endmodule