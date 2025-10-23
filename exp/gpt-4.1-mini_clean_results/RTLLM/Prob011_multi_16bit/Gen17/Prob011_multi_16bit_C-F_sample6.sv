module multi_16bit (
    input          clk,
    input          rst_n,   // asynchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count: 0 to 17
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg_ext;
    reg [31:0]   yout_r;

    wire         cnt_enable   = start && (i < 5'd17);
    wire         shift_phase  = start && (i > 5'd0) && (i < 5'd17);
    wire         load_inputs  = start && (i == 5'd0);
    wire         accumulate_en = shift_phase && areg[0];

    wire [31:0]  add_res = yout_r + breg_ext;

    // Shift count register with asynchronous reset and start reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (cnt_enable)
            i <= i + 5'd1;
    end

    // Done flag register with asynchronous reset and cleared on start deassert
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (!start)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
    end

    // Shift and accumulate operation with enable gating to reduce toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else if (!start) begin
            // Hold previous values when start is low (do not clear)
            areg    <= areg;
            breg_ext <= breg_ext;
            yout_r  <= yout_r;
        end else begin
            if (load_inputs) begin
                // Load inputs and clear accumulator
                areg    <= ain;
                breg_ext <= {16'd0, bin};
                yout_r  <= 32'd0;
            end else if (shift_phase) begin
                // Conditional accumulate
                if (accumulate_en)
                    yout_r <= add_res;
                // Else hold yout_r
                
                // Shift registers
                areg    <= areg >> 1;
                breg_ext <= breg_ext << 1;
            end else begin
                // Hold values outside multiplication phase
                areg    <= areg;
                breg_ext <= breg_ext;
                yout_r  <= yout_r;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule