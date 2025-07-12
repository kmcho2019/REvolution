module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Segment control
    reg [2:0] seg_ptr;
    always @(posedge clk) begin
        if (load) seg_ptr <= 3'b0;
        else seg_ptr <= seg_ptr + 1;
    end

    // State update logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update current segment
            case (seg_ptr)
                3'd0: update_segment(0, 63);
                3'd1: update_segment(64, 127);
                3'd2: update_segment(128, 191);
                3'd3: update_segment(192, 255);
                3'd4: update_segment(256, 319);
                3'd5: update_segment(320, 383);
                3'd6: update_segment(384, 447);
                3'd7: update_segment(448, 511);
            endcase
        end
    end

    // Task to update a segment of bits
    task update_segment;
        input integer start;
        input integer end;
        integer i;
        begin
            for (i = start; i <= end; i = i + 1) begin
                // Get neighbors with boundary conditions
                reg left, center, right;
                center = q[i];
                left = (i == 511) ? 1'b0 : q[i+1];
                right = (i == 0) ? 1'b0 : q[i-1];

                // Apply Rule 110
                case ({left, center, right})
                    3'b111: q[i] <= 1'b0;
                    3'b110: q[i] <= 1'b1;
                    3'b101: q[i] <= 1'b1;
                    3'b100: q[i] <= 1'b0;
                    3'b011: q[i] <= 1'b1;
                    3'b010: q[i] <= 1'b1;
                    3'b001: q[i] <= 1'b1;
                    3'b000: q[i] <= 1'b0;
                endcase
            end
        end
    endtask

endmodule