module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;
    localparam STATE_C = 2'b10;
    localparam STATE_D = 2'b11;
    
    reg [1:0] state;
    reg [1:0] priority_offset; // Rotating priority offset
    
    // Next state and priority rotation logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            priority_offset <= 2'b00;
        end else begin
            case (state)
                STATE_A: begin
                    // Evaluate requests in rotated priority order
                    case (priority_offset)
                        2'b00: begin // Original priority 0>1>2
                            if (r[0]) begin
                                state <= STATE_B;
                            end else if (r[1]) begin
                                state <= STATE_C;
                            end else if (r[2]) begin
                                state <= STATE_D;
                            end
                        end
                        2'b01: begin // Rotated priority 1>2>0
                            if (r[1]) begin
                                state <= STATE_C;
                            end else if (r[2]) begin
                                state <= STATE_D;
                            end else if (r[0]) begin
                                state <= STATE_B;
                            end
                        end
                        2'b10: begin // Rotated priority 2>0>1
                            if (r[2]) begin
                                state <= STATE_D;
                            end else if (r[0]) begin
                                state <= STATE_B;
                            end else if (r[1]) begin
                                state <= STATE_C;
                            end
                        end
                        default: state <= STATE_A;
                    endcase
                end
                STATE_B: begin
                    if (!r[0]) begin
                        state <= STATE_A;
                        priority_offset <= priority_offset + 1; // Rotate priority
                    end
                end
                STATE_C: begin
                    if (!r[1]) begin
                        state <= STATE_A;
                        priority_offset <= priority_offset + 1; // Rotate priority
                    end
                end
                STATE_D: begin
                    if (!r[2]) begin
                        state <= STATE_A;
                        priority_offset <= priority_offset + 1; // Rotate priority
                    end
                end
            endcase
        end
    end

    // Output logic - combinational
    assign g[0] = (state == STATE_B);
    assign g[1] = (state == STATE_C);
    assign g[2] = (state == STATE_D);

endmodule