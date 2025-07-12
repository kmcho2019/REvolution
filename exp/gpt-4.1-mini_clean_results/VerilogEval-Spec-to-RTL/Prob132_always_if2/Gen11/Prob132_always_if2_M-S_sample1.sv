module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = 0;
        keep_driving = 0;
        if (cpu_overheated)
            shut_off_computer = 1;
        if (~arrived && ~gas_tank_empty)
            keep_driving = 1;
    end

endmodule