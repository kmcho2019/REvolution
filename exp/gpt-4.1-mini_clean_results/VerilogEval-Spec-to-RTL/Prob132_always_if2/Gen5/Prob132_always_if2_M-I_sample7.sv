module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Logic for shut_off_computer output
    always @(*) begin
        shut_off_computer = 1'b0;
        if (cpu_overheated)
            shut_off_computer = 1'b1;
    end

    // Logic for keep_driving output
    always @(*) begin
        keep_driving = 1'b0;
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule