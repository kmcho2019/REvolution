module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [1:0] state;
reg [5:0] hours_reg;
reg [5:0] mins_reg;
reg [5:0] secs_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 2'd0; // Reset state
        hours_reg <= 6'd0;
        mins_reg <= 6'd0;
        secs_reg <= 6'd0;
    end else begin
        case (state)
            2'd0: begin // Reset state
                state <= 2'd1; // Transition to idle state
            end
            2'd1: begin // Idle state
                if (secs_reg == 6'd59) begin
                    secs_reg <= 6'd0;
                    if (mins_reg == 6'd59) begin
                        mins_reg <= 6'd0;
                        if (hours_reg == 6'd23) begin
                            hours_reg <= 6'd0;
                        end else begin
                            hours_reg <= hours_reg + 1'd1;
                        end
                    end else begin
                        mins_reg <= mins_reg + 1'd1;
                    end
                end else begin
                    secs_reg <= secs_reg + 1'd1;
                end
                state <= 2'd2; // Transition to update state
            end
            2'd2: begin // Update state
                state <= 2'd1; // Transition back to idle state
            end
            default: begin
                state <= 2'd0; // Reset state
            end
        endcase
    end
end

assign Hours = hours_reg;
assign Mins = mins_reg;
assign Secs = secs_reg;

endmodule