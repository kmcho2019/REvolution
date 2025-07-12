module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding for z=0 and z=1 partitions
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b11,
                     D = 2'b10;

    localparam [1:0] E = 2'b01,
                     F = 2'b10;

    reg [1:0] state_z0;  // States with z=0
    reg [1:0] state_z1;  // States with z=1
    reg active_partition; // 0=z0, 1=z1

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state_z0 <= A;
            state_z1 <= E; // Don't care, but initialized
            active_partition <= 0;
        end
        else if (!active_partition) begin
            // z=0 partition active
            case (state_z0)
                A: begin
                    if (w) begin
                        state_z0 <= B;
                    end
                end
                B: begin
                    if (w) begin
                        state_z0 <= C;
                    end else begin
                        state_z0 <= D;
                    end
                end
                C: begin
                    if (w) begin
                        state_z0 <= 2'b00; // Don't care (transition to z1)
                        active_partition <= 1;
                        state_z1 <= E;
                    end else begin
                        state_z0 <= D;
                    end
                end
                D: begin
                    if (w) begin
                        state_z0 <= 2'b00; // Don't care (transition to z1)
                        active_partition <= 1;
                        state_z1 <= F;
                    end else begin
                        state_z0 <= A;
                    end
                end
            endcase
        end
        else begin
            // z=1 partition active
            case (state_z1)
                E: begin
                    if (!w) begin
                        state_z1 <= 2'b00; // Don't care (transition to z0)
                        active_partition <= 0;
                        state_z0 <= D;
                    end
                end
                F: begin
                    if (w) begin
                        state_z1 <= 2'b00; // Don't care (transition to z0)
                        active_partition <= 0;
                        state_z0 <= C;
                    end else begin
                        state_z1 <= 2'b00; // Don't care (transition to z0)
                        active_partition <= 0;
                        state_z0 <= D;
                    end
                end
            endcase
        end
    end

    // Output is determined by active partition
    assign z = active_partition;

endmodule