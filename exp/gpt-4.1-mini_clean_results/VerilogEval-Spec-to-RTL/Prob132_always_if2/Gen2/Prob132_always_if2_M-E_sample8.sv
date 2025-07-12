module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Combinational logic for shut_off_computer
    always @(*) begin
        shut_off_computer = 0;           // default assignment
        if (cpu_overheated) begin
            shut_off_computer = 1;
        end
    end

    // Combinational logic for keep_driving
    always @(*) begin
        keep_driving = 0;                // default assignment
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule