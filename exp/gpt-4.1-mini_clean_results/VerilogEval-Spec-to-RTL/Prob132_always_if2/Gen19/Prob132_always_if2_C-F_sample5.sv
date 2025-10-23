module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Combinational logic for shut_off_computer
    always @(*) begin
        shut_off_computer = cpu_overheated;
    end

    // Combinational logic for keep_driving
    always @(*) begin
        keep_driving = (~arrived) & (~gas_tank_empty);
    end

endmodule