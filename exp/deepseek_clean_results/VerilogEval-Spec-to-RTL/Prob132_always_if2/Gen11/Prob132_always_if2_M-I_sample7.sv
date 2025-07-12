module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // CPU control - simple priority logic
    always @(*) begin
        shut_off_computer = cpu_overheated;
    end

    // Driving control - independent logic
    always @(*) begin
        keep_driving = ~arrived & ~gas_tank_empty;
    end

endmodule