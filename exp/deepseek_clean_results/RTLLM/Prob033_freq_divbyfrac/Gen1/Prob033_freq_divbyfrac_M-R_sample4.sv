module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [1:0] state;
reg [1:0] next_state;
reg clk_early;
wire clk_late;

// State definitions
localparam S_4CYCLE = 2'b00;
localparam S_3CYCLE = 2'b01;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_4CYCLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_4CYCLE: next_state = S_3CYCLE;
        S_3CYCLE: next_state = S_4CYCLE;
        default: next_state = S_4CYCLE;
    endcase
end

// Early clock generation (toggles at posedge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_early <= 1'b0;
    end else begin
        if ((state == S_4CYCLE && counter == 3) ||
            (state == S_3CYCLE && counter == 2)) begin
            clk_early <= ~clk_early;
        end
    end
end

// Counter for each state period
reg [1:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'b00;
    end else begin
        if ((state == S_4CYCLE && counter == 3) ||
            (state == S_3CYCLE && counter == 2)) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Late clock generation (half-cycle delayed)
reg clk_late_reg;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_late_reg <= 1'b0;
    end else begin
        clk_late_reg <= clk_early;
    end
end

assign clk_late = clk_late_reg;
assign clk_div = clk_early | clk_late;

endmodule