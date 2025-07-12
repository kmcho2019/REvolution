module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'd0;
localparam STATE_B = 2'd1;
localparam STATE_C = 2'd2;
localparam STATE_D = 2'd3;

reg [1:0] state;
reg [1:0] timeout;
reg [2:0] x_history;
reg g_internal;

// Output assignments
assign f = (state == STATE_B);
assign g = g_internal;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        g_internal <= 0;
        timeout <= 0;
        x_history <= 0;
    end
    else begin
        case (state)
            STATE_A: begin
                state <= STATE_B;
            end
            
            STATE_B: begin
                state <= STATE_C;
            end
            
            STATE_C: begin
                x_history <= {x_history[1:0], x};
                if (x_history[2:0] == 3'b101) begin
                    state <= STATE_D;
                    g_internal <= 1;
                    timeout <= 0;
                end
            end
            
            STATE_D: begin
                if (timeout < 2) begin
                    if (y) begin
                        // Keep g_internal at 1 permanently
                    end
                    else begin
                        timeout <= timeout + 1;
                        if (timeout == 1) begin
                            g_internal <= 0;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule