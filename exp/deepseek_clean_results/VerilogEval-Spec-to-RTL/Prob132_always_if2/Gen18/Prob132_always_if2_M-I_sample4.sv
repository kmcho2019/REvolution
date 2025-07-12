module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Computer control logic
        shut_off_computer = cpu_overheated;
        
        // Driving control logic
        keep_driving = ~arrived & ~gas_tank_empty;
    end

endmodule