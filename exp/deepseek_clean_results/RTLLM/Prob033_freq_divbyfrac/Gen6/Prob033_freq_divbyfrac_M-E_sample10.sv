module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [1:0] state;
reg toggle;
reg comp_pulse;
reg last_toggle;

// State machine states
localparam S_WAIT_3 = 2'b00;
localparam S_WAIT_4 = 2'b01;
localparam S_COMP = 2'b10;

// Main state machine and toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_WAIT_3;
        toggle <= 1'b0;
        last_toggle <= 1'b0;
    end else begin
        last_toggle <= toggle;
        
        case (state)
            S_WAIT_3: begin
                if (toggle != last_toggle) begin
                    state <= S_WAIT_4;
                    toggle <= ~toggle;
                end
            end
            S_WAIT_4: begin
                if (toggle != last_toggle) begin
                    state <= S_COMP;
                    toggle <= ~toggle;
                end
            end
            S_COMP: begin
                state <= S_WAIT_3;
            end
        endcase
    end
end

// Compensation pulse generation on falling edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        comp_pulse <= 1'b0;
    end else begin
        comp_pulse <= (state == S_COMP);
    end
end

// Final output combining base toggle and compensation
assign clk_div = toggle | comp_pulse;

endmodule