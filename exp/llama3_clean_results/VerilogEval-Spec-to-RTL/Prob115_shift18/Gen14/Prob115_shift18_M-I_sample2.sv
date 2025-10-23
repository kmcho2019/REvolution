module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
wire [63:0] next_q;

// Divide the 64-bit data into eight 8-bit segments
wire [7:0][7:0] next_q_seg;
reg [7:0][7:0] q_reg_seg;

// Initialize the segment registers
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 8; i++) begin
            q_reg_seg[i] <= data[i*8 +: 8];
        end
    end else if (ena) begin
        case (amount)
            2'b00: begin
                for (int i = 0; i < 7; i++) begin
                    q_reg_seg[i] <= q_reg_seg[i][6:0] + {7{1'b0}};
                end
                q_reg_seg[7] <= q_reg_seg[7][6:0] + {7{1'b0}};
            end
            2'b01: begin
                for (int i = 0; i < 7; i++) begin
                    q_reg_seg[i] <= q_reg_seg[i+1][7:0];
                end
                q_reg_seg[7] <= {8{1'b0}};
            end
            2'b10: begin
                for (int i = 1; i < 8; i++) begin
                    q_reg_seg[i] <= {q_reg_seg[i-1][7], q_reg_seg[i-1][7:1]};
                end
                q_reg_seg[0] <= {q_reg_seg[0][7], q_reg_seg[0][7:1]};
            end
            2'b11: begin
                for (int i = 1; i < 8; i++) begin
                    q_reg_seg[i] <= {q_reg_seg[i-1][7], q_reg_seg[i-1][7:1]};
                end
                q_reg_seg[0] <= {{8{q_reg_seg[0][7]}}, q_reg_seg[0][7:1]};
            end
            default: begin
                for (int i = 0; i < 8; i++) begin
                    q_reg_seg[i] <= q_reg_seg[i];
                end
            end
        endcase
    end
end

// Combine the segment registers
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        next_q[i*8 +: 8] <= q_reg_seg[i];
    end
end

assign q = next_q;

endmodule