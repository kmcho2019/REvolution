module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [2:0] shift_counter;
reg shifting;
reg shift_dir;  // 0=left, 1=right
reg shift_size; // 0=1bit, 1=8bit

always @(posedge clk) begin
    if (load) begin
        q <= data;
        shifting <= 1'b0;
    end else if (ena) begin
        if (!shifting) begin
            // Start new shift operation
            shift_dir <= amount[1];
            shift_size <= amount[0];
            shifting <= 1'b1;
            shift_counter <= 3'b0;
        end else begin
            // Continue shift operation
            if (shift_dir) begin // Right shift
                if (shift_size) begin // 8-bit
                    if (shift_counter < 3'd7) begin
                        q <= {q[63], q[63:1]}; // Arithmetic right by 1
                        shift_counter <= shift_counter + 1;
                    end else begin
                        shifting <= 1'b0;
                    end
                end else begin // 1-bit
                    q <= {q[63], q[63:1]}; // Arithmetic right by 1
                    shifting <= 1'b0;
                end
            end else begin // Left shift
                if (shift_size) begin // 8-bit
                    if (shift_counter < 3'd7) begin
                        q <= {q[62:0], 1'b0}; // Left by 1
                        shift_counter <= shift_counter + 1;
                    end else begin
                        shifting <= 1'b0;
                    end
                end else begin // 1-bit
                    q <= {q[62:0], 1'b0}; // Left by 1
                    shifting <= 1'b0;
                end
            end
        end
    end
end

endmodule