module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [2:0] shift_counter;
reg [63:0] shift_buffer;
reg shifting;
reg shift_dir;  // 0=left, 1=right

always @(posedge clk) begin
    if (load) begin
        q <= data;
        shifting <= 1'b0;
        shift_counter <= 3'b0;
    end else if (ena) begin
        if (!shifting) begin
            // Start new shift operation
            case (amount)
                2'b00: begin // Shift left by 1
                    q <= {q[62:0], 1'b0};
                end
                2'b01: begin // Shift left by 8 (multi-cycle)
                    shift_buffer <= {q[55:0], 8'b0};
                    shifting <= 1'b1;
                    shift_counter <= 3'd7;
                    shift_dir <= 1'b0;
                end
                2'b10: begin // Arithmetic right by 1
                    q <= {q[63], q[63:1]};
                end
                2'b11: begin // Arithmetic right by 8 (multi-cycle)
                    shift_buffer <= {{8{q[63]}}, q[63:8]};
                    shifting <= 1'b1;
                    shift_counter <= 3'd7;
                    shift_dir <= 1'b1;
                end
            endcase
        end else begin
            // Continue multi-cycle shift
            if (shift_counter != 0) begin
                shift_counter <= shift_counter - 1;
            end else begin
                q <= shift_buffer;
                shifting <= 1'b0;
            end
        end
    end
end

endmodule