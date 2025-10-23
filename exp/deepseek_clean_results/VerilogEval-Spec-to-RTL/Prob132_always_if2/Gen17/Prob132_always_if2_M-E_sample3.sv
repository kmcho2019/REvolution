module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Computer control logic
    always @(*) begin
        shut_off_computer = 1'b0;  // Default value
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end
    end

    // Driving control logic
    always @(*) begin
        keep_driving = 1'b0;  // Default value
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule