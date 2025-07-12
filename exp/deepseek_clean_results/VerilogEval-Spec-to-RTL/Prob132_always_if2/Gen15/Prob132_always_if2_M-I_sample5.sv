module TopModule (
    input  cpu_overheated,    // Thermal emergency signal
    input  arrived,           // Destination reached
    input  gas_tank_empty,    // Fuel status
    output shut_off_computer, // Emergency shutdown
    output keep_driving       // Continue driving signal
);

    // Computer control - priority signal
    assign shut_off_computer = (cpu_overheated) ? 1'b1 : 1'b0;
    
    // Driving logic - continue unless arrived or empty tank
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule