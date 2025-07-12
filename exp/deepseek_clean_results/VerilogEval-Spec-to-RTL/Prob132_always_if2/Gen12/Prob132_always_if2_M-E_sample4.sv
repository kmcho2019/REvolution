module TopModule (
    input clk,
    input reset_n,
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    // Registered output for CPU overheating (immediate response but synchronized)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shut_off_computer <= 0;
        end else begin
            shut_off_computer <= cpu_overheated;
        end
    end

    // State machine for driving logic
    reg driving_state;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            driving_state <= 0;
            keep_driving <= 0;
        end else begin
            driving_state <= ~arrived;
            keep_driving <= driving_state & ~gas_tank_empty;
        end
    end

endmodule