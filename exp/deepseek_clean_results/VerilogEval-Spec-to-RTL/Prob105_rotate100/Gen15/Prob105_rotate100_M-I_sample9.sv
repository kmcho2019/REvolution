module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] next_q;
reg rotate_en;
reg rotate_dir; // 0 for right, 1 for left

// Clock gating logic
wire gated_clk = clk & (load | (|ena));

always @(*) begin
    if (load) begin
        next_q = data;
        rotate_en = 1'b0;
    end else begin
        case (ena)
            2'b01: begin
                next_q = {q[0], q[99:1]};
                rotate_en = 1'b1;
                rotate_dir = 1'b0;
            end
            2'b10: begin
                next_q = {q[98:0], q[99]};
                rotate_en = 1'b1;
                rotate_dir = 1'b1;
            end
            default: begin
                next_q = q;
                rotate_en = 1'b0;
            end
        endcase
    end
end

// Pipeline stage
reg [99:0] rotation_stage;

always @(posedge gated_clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_en) begin
        if (rotate_dir)
            rotation_stage <= {q[98:0], q[99]}; // Left
        else
            rotation_stage <= {q[0], q[99:1]}; // Right
    end
end

// Final output stage
always @(posedge clk) begin
    if (rotate_en)
        q <= rotation_stage;
end

endmodule