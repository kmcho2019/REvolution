module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Base counters for 3x and 4x division
reg [1:0] cnt3;
reg [2:0] cnt4;
reg clk3, clk4;

// Phase-shifted versions
reg clk3_90, clk3_180, clk3_270;
reg clk4_90, clk4_180, clk4_270;

// Cycle selection state machine
reg cycle_sel; // 0=3-cycle, 1=4-cycle
reg [2:0] seq_counter;

// Output generation
reg [3:0] phase_sel;
wire [3:0] phase_mux;

// Generate base 3x divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt3 <= 2'b0;
        clk3 <= 1'b0;
    end else begin
        if (cnt3 == 2'd2) begin
            cnt3 <= 2'b0;
            clk3 <= ~clk3;
        end else begin
            cnt3 <= cnt3 + 1'b1;
        end
    end
end

// Generate base 4x divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt4 <= 3'b0;
        clk4 <= 1'b0;
    end else begin
        if (cnt4 == 3'd3) begin
            cnt4 <= 3'b0;
            clk4 <= ~clk4;
        end else begin
            cnt4 <= cnt4 + 1'b1;
        end
    end
end

// Create phase-shifted versions (90° steps)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk3_90 <= 1'b0;
        clk3_180 <= 1'b0;
        clk3_270 <= 1'b0;
        clk4_90 <= 1'b0;
        clk4_180 <= 1'b0;
        clk4_270 <= 1'b0;
    end else begin
        clk3_90 <= clk3;
        clk3_180 <= clk3_90;
        clk3_270 <= clk3_180;
        clk4_90 <= clk4;
        clk4_180 <= clk4_90;
        clk4_270 <= clk4_180;
    end
end

// Cycle selection state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_sel <= 1'b0;
        seq_counter <= 3'b0;
    end else begin
        if (seq_counter == 3'd6) begin
            seq_counter <= 3'b0;
            cycle_sel <= ~cycle_sel;
        end else begin
            seq_counter <= seq_counter + 1'b1;
        end
    end
end

// Phase selection logic
always @(*) begin
    case (seq_counter)
        3'd0: phase_sel = {clk3, clk3_90, clk3_180, clk3_270};
        3'd1: phase_sel = {clk3_90, clk3_180, clk3_270, clk3};
        3'd2: phase_sel = {clk3_180, clk3_270, clk3, clk3_90};
        3'd3: phase_sel = {clk4, clk4_90, clk4_180, clk4_270};
        3'd4: phase_sel = {clk4_90, clk4_180, clk4_270, clk4};
        3'd5: phase_sel = {clk4_180, clk4_270, clk4, clk4_90};
        default: phase_sel = 4'b0;
    endcase
end

// Output phase multiplexer
assign phase_mux = (cycle_sel) ? 
                  {clk4, clk4_90, clk4_180, clk4_270} : 
                  {clk3, clk3_90, clk3_180, clk3_270};

assign clk_div = |phase_mux;

endmodule