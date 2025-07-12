module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = cpu_overheated ? 1 : 0;
        keep_driving = (~arrived) ? ~gas_tank_empty : 0;
    end

endmodule