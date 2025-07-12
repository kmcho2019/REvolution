module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = 0; // Default value when cpu_overheated is 0
        if (cpu_overheated)
           shut_off_computer = 1;
    end

    always @(*) begin
        if (arrived)
           keep_driving = 0; // Stop driving when arrived
        else if (~gas_tank_empty)
           keep_driving = 1; // Keep driving when not arrived and gas tank is not empty
        else
           keep_driving = 0; // Stop driving when gas tank is empty
    end

endmodule