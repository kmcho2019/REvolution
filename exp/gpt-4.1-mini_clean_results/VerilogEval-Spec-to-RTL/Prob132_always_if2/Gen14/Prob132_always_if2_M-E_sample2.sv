module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    wire shut_off_wire;
    wire keep_drive_wire;

    // Combinational logic as wires
    assign shut_off_wire = cpu_overheated;
    assign keep_drive_wire = (~arrived) & (~gas_tank_empty);

    always @(*) begin
        shut_off_computer = shut_off_wire;
        keep_driving = keep_drive_wire;
    end

endmodule