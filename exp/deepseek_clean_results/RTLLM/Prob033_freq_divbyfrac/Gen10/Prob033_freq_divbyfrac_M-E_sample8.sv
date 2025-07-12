module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] main_counter;
reg half_cycle_flag;
reg toggle;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
        half_cycle_flag <= 1'b0;
    end else begin
        if (main_counter == 6) begin
            main_counter <= 3'b0;
            half_cycle_flag <= ~half_cycle_flag;
        end else begin
            main_counter <= main_counter + 1;
        end
    end
end

// Toggle flip-flop for base clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else begin
        if (main_counter == 0 || 
            (half_cycle_flag && main_counter == 3)) begin
            toggle <= ~toggle;
        end
    end
end

// Phase compensator
reg phase_comp;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_comp <= 1'b0;
    end else begin
        if ((half_cycle_flag && main_counter == 1) ||
            (!half_cycle_flag && main_counter == 4)) begin
            phase_comp <= 1'b1;
        end else begin
            phase_comp <= 1'b0;
        end
    end
end

// Final output
always @(*) begin
    clk_div = toggle ^ phase_comp;
end

endmodule