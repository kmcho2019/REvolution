module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] main_counter;
reg sub_counter;
reg [1:0] phase_select;

// Main 7-cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
        sub_counter <= 1'b0;
    end else begin
        if (main_counter == 3'd6) begin
            main_counter <= 3'b0;
            sub_counter <= ~sub_counter;
        end else begin
            main_counter <= main_counter + 1'b1;
        end
    end
end

// Phase selection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_select <= 2'b01;
    end else begin
        if (main_counter == 3'd6) begin
            phase_select <= {phase_select[0], phase_select[1]};
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        case (phase_select)
            2'b01: clk_div <= (main_counter < 3'd4);
            2'b10: clk_div <= (main_counter < 3'd3);
            default: clk_div <= 1'b0;
        endcase
    end
end

endmodule