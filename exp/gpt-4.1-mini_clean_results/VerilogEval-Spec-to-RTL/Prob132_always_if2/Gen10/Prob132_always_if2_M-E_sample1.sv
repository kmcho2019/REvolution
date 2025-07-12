module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Always block for shut_off_computer with default assignment
    always @(*) begin
        shut_off_computer = 0;
        if (cpu_overheated)
            shut_off_computer = 1;
    end

    // Always block for keep_driving with default assignment
    always @(*) begin
        keep_driving = 0;
        if (~arrived && ~gas_tank_empty)
            keep_driving = 1;
    end

endmodule