module TopModule (
    input clk,
    input reset,
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shut_off_computer <= 0;
            keep_driving <= 0;
        end
        else begin
            shut_off_computer <= cpu_overheated;
            keep_driving <= ~arrived & ~gas_tank_empty;
        end
    end

endmodule