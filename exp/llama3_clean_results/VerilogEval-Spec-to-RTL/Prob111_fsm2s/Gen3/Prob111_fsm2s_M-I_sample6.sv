module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the states
enum {OFF, ON} state;

// State transition and output logic combined
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                    out <= 1'b1;
                end else begin
                    state <= OFF;
                    out <= 1'b0;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                    out <= 1'b0;
                end else begin
                    state <= ON;
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule