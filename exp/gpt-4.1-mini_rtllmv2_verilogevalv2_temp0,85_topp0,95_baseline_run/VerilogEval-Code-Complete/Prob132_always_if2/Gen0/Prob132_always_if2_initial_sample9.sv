module top_module (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // default assignment to avoid latches
        shut_off_computer = 0;
        if (cpu_overheated)
            shut_off_computer = 1;
    end

    always @(*) begin
        // default assignment to avoid latches
        keep_driving = 0;
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule