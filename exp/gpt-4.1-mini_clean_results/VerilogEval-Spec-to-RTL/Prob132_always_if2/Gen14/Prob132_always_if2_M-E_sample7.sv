module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Control shut_off_computer based on cpu_overheated signal
    always @(*) begin
        shut_off_computer = 0;          // default value
        if (cpu_overheated) begin
            shut_off_computer = 1;
        end
    end

    // Control keep_driving based on arrived and gas_tank_empty signals
    always @(*) begin
        keep_driving = 0;               // default value
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule