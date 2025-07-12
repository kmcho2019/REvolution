module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt;
logic clk_vco;
logic clk_div_int;

// Phase detector
logic phase_error;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Loop filter
logic [7:0] loop_filter_out;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        loop_filter_out <= 8'd0;
    end else begin
        if (phase_error) begin
            loop_filter_out <= loop_filter_out + 8'd1;
        end else begin
            loop_filter_out <= loop_filter_out - 8'd1;
        end
    end
end

// VCO
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_vco <= 1'b0;
    end else begin
        if (loop_filter_out > 8'd100) begin
            clk_vco <= ~clk_vco;
        end
    end
end

// Phase detector
always_comb begin
    if (clk == clk_vco) begin
        phase_error <= 1'b0;
    end else begin
        phase_error <= 1'b1;
    end
end

// Clock divider
assign clk_div = clk_div_int;

endmodule